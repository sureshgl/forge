package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Type_referenceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Type_referenceContextExt extends AbstractBaseExt {

	public Type_referenceContextExt(Type_referenceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_referenceContext getContext() {
		return (Type_referenceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_reference());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_referenceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_referenceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}