package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Method_qualifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Method_qualifierContextExt extends AbstractBaseExt {

	public Method_qualifierContextExt(Method_qualifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Method_qualifierContext getContext() {
		return (Method_qualifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).method_qualifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Method_qualifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Method_qualifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}