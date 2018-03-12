package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Reference_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Reference_eventContextExt extends AbstractBaseExt {

	public Reference_eventContextExt(Reference_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Reference_eventContext getContext() {
		return (Reference_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).reference_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Reference_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Reference_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}