package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.System_tf_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class System_tf_identifierContextExt extends AbstractBaseExt {

	public System_tf_identifierContextExt(System_tf_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public System_tf_identifierContext getContext() {
		return (System_tf_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).system_tf_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof System_tf_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ System_tf_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}