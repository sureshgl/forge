package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bind_target_scopeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bind_target_scopeContextExt extends AbstractBaseExt {

	public Bind_target_scopeContextExt(Bind_target_scopeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bind_target_scopeContext getContext() {
		return (Bind_target_scopeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bind_target_scope());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bind_target_scopeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bind_target_scopeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}