package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Extern_tf_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Extern_tf_declarationContextExt extends AbstractBaseExt {

	public Extern_tf_declarationContextExt(Extern_tf_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Extern_tf_declarationContext getContext() {
		return (Extern_tf_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).extern_tf_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Extern_tf_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Extern_tf_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}